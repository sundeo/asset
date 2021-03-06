module Asset
  class Util

    # Get timestamp
    def self.mtime(path)
      File.mtime(asset_path(path))
    end

    # Asset path
    def self.asset_path(path)
      File.join(::Asset.path, File.split(path))
    end

    # Digest
    def self.digest(path, time)
      Digest::MD5.hexdigest(%{#{path}#{time.to_i}})
    end

    # Load manifest
    def self.load_manifest
      list = YAML.load_file(File.join(::Asset.path, 'manifest.yml'))
      manifest = []

      list.each do |type, files|
        max = Time.new(0).utc
        files.each do |name|

          # Depending on the options, the name can be a string or a Hash
          h = name.is_a?(Hash)

          # Path looks like app.js or similar
          path = h ? name.keys[0] : name

          # Get the modified time of the asset
          modified = mtime("#{type}/#{path}").utc

          # Record max to know the latest change
          max = modified if modified > max

          # Loading manifest with items
          manifest << ::Asset::Item.new(
            path, type, digest(path, modified), modified,
            (h ? name['compress'] : true), (h ? name['bundle'] : true))
        end

        # Insert the application bundle
        manifest.insert(0, ::Asset::Item.new(
          "application.#{type}", type,
          digest("application.#{type}", max), max))
      end
      manifest
    end

  end
end
