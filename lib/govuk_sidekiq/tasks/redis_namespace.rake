namespace :redis_namespace do
  desc "Remove application specific namespacing for all Redis keys"
  task :remove_namespace, :environment do
    namespace = ENV["GOVUK_APP_NAME"]

    redis = RedisClient.new(url: ENV["REDIS_URL"])

    namespaced_keys = redis.call("KEYS", "#{namespace}:*")

    namespaced_keys.each do |key|
      new_key = key.gsub(/^#{namespace}:/, "")
      redis.call("RENAME", key, new_key)
    end
  end
end
