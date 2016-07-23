namespace :deploy do
  namespace :assets do
    desc "Precompile assets if changed"
    task :precompile_changed do
      # clear the previous precompile task
      Rake::Task["deploy:assets:precompile"].clear_actions
      class PrecompileRequired < StandardError; end

      on roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            begin

              # find the most recent release
              latest_release = capture(:ls, '-xr', releases_path).split[1]

              # precompile if this is the first deploy
              raise PrecompileRequired unless latest_release

              #
              latest_release_path = releases_path.join(latest_release)

              # precompile if the previous deploy failed to finish precompiling
              execute(:ls, latest_release_path.join('assets_manifest_backup')) rescue raise(PrecompileRequired)

              fetch(:assets_dependencies).each do |dep|
                #execute(:du, '-b', release_path.join(dep)) rescue raise(PrecompileRequired)
                #execute(:du, '-b', latest_release_path.join(dep)) rescue raise(PrecompileRequired)

                # execute raises if there is a diff
                execute(:diff, '-Naur', release_path.join(dep), latest_release_path.join(dep)) rescue raise(PrecompileRequired)
              end

              warn("-----Skipping asset precompile, no asset diff found")

              # copy over all of the assets from the last release
              execute(:cp, '-rf', latest_release_path.join('public', fetch(:assets_prefix)), release_path.join('public', fetch(:assets_prefix)))

            rescue PrecompileRequired
              warn("----Run assets precompile")

              execute(:rake, "assets:precompile")
            end
          end
        end
      end
    end
  end
end

