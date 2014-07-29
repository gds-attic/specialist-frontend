class InternationalDevelopmentFundPresenter < DocumentPresenter
  delegate(
    :application_state,
    :location,
    :development_sector,
    :eligible_entities,
    :value_of_fund,
    to: :"document.details"
  )

  def format_name
    "International development funding"
  end

  def finder_path
    "/international-development-funding"
  end

private
  def filterable_metadata
    {
      application_state: application_state,
      location: location,
      development_sector: development_sector,
      eligible_entities: eligible_entities,
      value_of_fund: value_of_fund,
    }
  end
end