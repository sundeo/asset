module Asset
  module Helpers

    # Script tags
    def script_tag(*paths)
      tag('js', *paths) do |src|
        %{<script src="#{src}"></script>}
      end
    end

    # Style tags
    def style_tag(*paths)
      tag('css', *paths) do |src|
        %{<link href="#{src}" media="all" rel="stylesheet" type="text/css">}
      end
    end

    # Image tags
    def image_tag(path)
      b = ::Asset::Util.mtime("images/#{path}")
      %{<img src="/assets/images/#{CGI.escapeHTML(path)}#{b ? "?#{b.to_i}" : ''}">} rescue path
    end

    private

    # Build the tags
    def tag(type, *paths, &block)
      paths.map do |path|

        # Yield the source back to the tag builder
        item = ::Asset.manifest.find{|i| i.path == path}

        # Src is same as path if item not found
        item ? item.files.map{|src| yield(%{/assets/#{type}/#{src}})} : yield(path)

      end.flatten.join("\n")
    end

  end
end
