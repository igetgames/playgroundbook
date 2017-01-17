# encoding: utf-8
module Playgroundbook
  class PageProcessor
    def strip_extraneous_newlines(page_contents)
      # Three cases we need to look for:
      # - Extraneous newlines before /*:
      # - Extraneous newlines after */
      # - Extraneous newlines either before or after //:
      page_contents
        .gsub(/\n+\/\*:/, "\n/*:")
        .gsub(/\*\/\n+/, "*/\n")
        .split(/(\/\/:.*$)\n*/).join("\n") # Important to do this before the next line, because it adds newlines before //: comments.
        .gsub(/\n+\/\/:/, "\n//:")
    end

    def extract_live_view(page_contents)
      match = page_contents.match(/\/\/#-live-view(.+)\/\/#-end-live-view/m)

      if match
        live_view = match[1]
      end
      if live_view
        purged_contents = page_contents.gsub(match.to_s, "")
      else
        purged_contents = page_contents
      end

      {
        purged_content: purged_contents,
        live_view: live_view
      }
    end
  end
end
