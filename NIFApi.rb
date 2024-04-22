require_relative "./NIFConnection.rb"
require_relative "./modules/fetch_data.rb"
require_relative "./modules/org_types.rb"

class NIFApi
  include FetchData

  def initialize(scope:)
    @API = NIFConnection.new(
      scope: scope
    )
  end

  def all_clubs(with_logo: false)
    fetch_data(
      path: "org/AllClubs?logo=#{with_logo}",
      filename: "org_clubs_#{with_logo ? "with_logo" : "no_logos"}"
    )
  end

  def all_orgs
    ORG_TYPES.each do |org_type_id, org_type_name|
      all_orgs_of_type(org_type_id: org_type_id)
    end
  end

  def all_orgs_of_type(org_type_id:)
    fetch_data(
      path: "org/organisation/orgtype/#{org_type_id}",
      filename: "orgs__orgtype_#{ORG_TYPES[org_type_id]}"
    )
  end

  def teams_for_org(org_id:)
    fetch_data(
      path: "org/Teams?orgId=#{org_id}",
      filename: "org_teams"
    )
  end
end


nif_test = NIFApi.new(scope: 'data_org_read')

nif_test.all_clubs
nif_test.all_orgs
