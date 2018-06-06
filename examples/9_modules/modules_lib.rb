export do
  Module.new do
    def puts(message)
      super("<red>#{message}</red>")
    end
  end
end
