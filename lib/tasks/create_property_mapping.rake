require "elasticsearch-ruby"
namespace :mappings do
  desc "Create mapping for properties"
  task :create_property_mapping do
    #initiate ES client
    if Rails.env.production?
      client = Elasticsearch::Client.new host: '10.128.0.4'
    else
      client = Elasticsearch::Client.new log: true
    end

    body = {
      analysis: {
        filter: {
          autocomplete_filter: {
              type:     "edge_ngram",
              min_gram: 1,
              max_gram: 20
          },
          trigrams_filter: {
            type:     "ngram",
            min_gram: 3,
            max_gram: 3
          },
          quadgrams_filter: {
            type:     "ngram",
            min_gram: 4,
            max_gram: 4
          },
          address_synonyms: {
            type: "synonym",
            synonyms: [
              "1st,first","2nd,second","3rd,third","4th,fourth","5th,fifth",
              "6th,sixth","7th,seventh","8th,eighth","9th,ninth","10th,tenth",
              "11th,eleventh","12th,twelfth", "13th,thirteenth", "14th, fourteenth",
              "15th,fifteenth","16th,sixteenth","17th,seventeenth","18th,eighteenth",
              "19th,nineteenth",
              "20th,twentieth",
              "21st,twenty-first,twenty first",
              "22nd,twenty-second,twenty second",
              "23rd,twenty-third,twenty third",
              "24th,twnty-fourth,twenty fourth",
              "25th,twenty-fifth,twenty fifth",
              "26th,twenty-sixth,twenty sixth",
              "27th,twenty-seventh,twenty seventh",
              "28th,twenty-eighth,twenty eighth",
              "29th,twenty-ninth,twenty ninth",
              "n,north,n.","s,south,s.","w,west,w.","e,east,e.","nw, northwest, nw.",
              "ne,northeast,ne.","sw,southwest,sw.","se,southeast,se.",
              "ct,court,ct.,st,street,st.,dr,drive,dr.,blvd,boulevard,blvd.,rd,road,rd.,rte,rt,route,rte.,rt."
            ]
          }
        },
        analyzer: {
          autocomplete: {
            type:      "custom",
            tokenizer: "standard",
            filter: [
                "lowercase",
                "autocomplete_filter" 
            ]
          },
          trigrams: {
            type:      "custom",
            tokenizer: "standard",
            filter:   [
                "lowercase",
                "trigrams_filter"
            ]
          },
          quadgrams: {
            type:      "custom",
            tokenizer: "standard",
            filter:   [
                "lowercase",
                "quadgrams_filter"
            ]
          },
          case_insensitive_sort: {
            type: "custom",
            tokenizer: "keyword",
            filter:  [ "lowercase" ]
          },
          address: {
            type: "custom",
            tokenizer: "standard",
            filter: [
              "lowercase",
              "address_synonyms"
            ]
          }
        }
      }
    }

    index_name = "properties_#{Time.now.to_i}"

    #create a versioned index (this is to make re-indexing seemless later)
    client.indices.create index: index_name, body: body

    mapping = YAML.load(File.read("mapping.yml"))
    client.indices.put_mapping index: index_name, type: "property", body: mapping

    #create an alias that points 'properties' -> versioned index if an alias doesn't already exist
    #(see http://www.elasticsearch.org/blog/changing-mapping-with-zero-downtime/)
    #note: when an alias already exists we will not want to *immediately* point
    #  it at the new index. This will result in the alias pointing to two
    #  indices and preventing writes on both (you can, however,  still perform GETs in this situation)
    #  Instead, we will want to create the new index with the new mapping (as this file does),
    #  then reindex the data utilizing the 'reindex' task, then point the alias at the new index.
    #  Also note, any updates that have come in during reindexing will be lost
    #  and so we must then re-send any data that came in during that time
    unless client.indices.exists_alias? name: 'properties'
      client.indices.put_alias index: index_name, name: 'properties'
    end

  end
end

