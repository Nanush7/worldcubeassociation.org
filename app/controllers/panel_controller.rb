# frozen_string_literal: true

class PanelController < ApplicationController
  include DocumentsHelper
  include PanelHelper

  before_action :authenticate_user!
  before_action -> { redirect_to_root_unless_user(:has_permission?, 'can_access_panels', params[:panel_id].to_sym) }, only: [:index]
  before_action -> { redirect_to_root_unless_user(:can_access_panel?, params[:action].to_sym) }, except: [:pending_claims_for_subordinate_delegates, :index]
  before_action -> { redirect_to_root_unless_user(:can_access_senior_delegate_panel?) }, only: [:pending_claims_for_subordinate_delegates]

  def pending_claims_for_subordinate_delegates
    # Show pending claims for a given user, or the current user, if they can see them
    user_id = params[:user_id] || current_user.id
    @user = User.find(user_id)
    @subordinate_delegates = @user.subordinate_delegates.to_a.push(@user)
  end

  def index
    @panel_id = params.require(:panel_id)
    panel_details = panel_list(current_user)[@panel_id.to_sym]
    @pages = panel_details[:pages]
    @title = panel_details[:name]
  end

  def self.panel_pages
    {
      postingDashboard: "posting-dashboard",
      editPerson: "edit-person",
      regionsManager: "regions-manager",
      groupsManagerAdmin: "groups-manager-admin",
      bannedCompetitors: "banned-competitors",
      translators: "translators",
      duesExport: "dues-export",
      countryBands: "country-bands",
      delegateProbations: "delegate-probations",
      xeroUsers: "xero-users",
      duesRedirect: "dues-redirect",
      delegateForms: "delegate-forms",
      regions: "regions",
      subordinateDelegateClaims: "subordinate-delegate-claims",
      subordinateUpcomingCompetitions: "subordinate-upcoming-competitions",
      leaderForms: "leader-forms",
      groupsManager: "groups-manager",
      importantLinks: "important-links",
      delegateHandbook: "delegate-handbook",
      seniorDelegatesList: "senior-delegates-list",
      leadersAdmin: "leaders-admin",
      boardEditor: "board-editor",
      officersEditor: "officers-editor",
      regionsAdmin: "regions-admin",
      downloadVoters: "download-voters",
    }
  end
end
