# frozen_string_literal: true

export do
  Module.new do
    refine Kernel do
      def puts(message)
        super("<red>#{message}</red>")
      end
    end
  end
end
