require 'ostruct'

# Usage:
# settings = import('examples/6_settings')
# settings.algolia.app_id

# Remember, nil cannot be exported.
exports.algolia = OpenStruct.new(
  app_id: 'ABCD',
  api_key: '12CD'
)
