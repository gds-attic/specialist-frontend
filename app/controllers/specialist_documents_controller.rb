require 'gds_api/helpers'

class SpecialistDocumentsController < ApplicationController
  include GdsApi::Helpers

  def show
    artefact = content_api.artefact(params[:path])

    if artefact
      @document = document_presenter(artefact)
    else
      error_not_found
    end
  end

private

  def schema(name)
    finder_api.get_schema(name)
  end

  def error_not_found
    render status: :not_found, text: "404 error not found"
  end

  def document_presenter(artefact)
    case artefact.format
    when "aaib_report"
      AaibReportPresenter.new(schema("aaib-reports"), artefact)
    when "cma_case"
      CmaCasePresenter.new(schema("cma-cases"), artefact)
    when "drug_safety_update"
      DrugSafetyUpdatePresenter.new(schema("drug-safety-update"), artefact)
    when "international_development_fund"
      InternationalDevelopmentFundPresenter.new(schema("international-development-funding"), artefact)
    when "maib_report"
      MaibReportPresenter.new(schema("maib-reports"), artefact)
    when "medical_safety_alert"
      MedicalSafetyAlertPresenter.new(schema("drug-device-alerts"), artefact)
    when "raib_report"
      RaibReportPresenter.new(schema("raib-reports"), artefact)
    else
      DocumentPresenter.new(NullSchema.new, artefact)
    end
  end

  class NullSchema
    def user_friendly_values(input)
      input
    end
  end

  def set_robots_headers
    if finders_excluded_from_robots.include?(request.path.split('/')[1])
      response.headers["X-Robots-Tag"] = "none"
    end
  end

  def finders_excluded_from_robots
    [
      'aaib-reports',
      'drug-safety-update',
      'drug-device-alerts',
      'maib-reports',
      'raib-reports',
    ]
  end

end
