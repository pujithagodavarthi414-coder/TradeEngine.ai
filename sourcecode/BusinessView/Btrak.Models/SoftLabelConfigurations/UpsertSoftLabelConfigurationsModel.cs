using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.SoftLabelConfigurations
{
    public class UpsertSoftLabelConfigurationsModel : InputModelBase
    {
        public UpsertSoftLabelConfigurationsModel() : base(InputTypeGuidConstants.UpsertSoftLabelConfigurationsCommandTypeGuid)
        {
        }
        public Guid? SoftLabelConfigurationId { get; set; }
        public string ProjectLabel { get; set; }
        public string GoalLabel { get; set; }
        public string EmployeeLabel { get; set; }
        public string DeadlineLabel { get; set; }
        public string UserStoryLabel { get; set; }
        public string ProjectsLabel { get; set; }
        public string GoalsLabel { get; set; }
        public string EmployeesLabel { get; set; }
        public string DeadlinesLabel { get; set; }
        public string UserStoriesLabel { get; set; }
        public string ScenarioLabel { get; set; }
        public string ScenariosLabel { get; set; }
        public string RunLabel { get; set; }
        public string RunsLabel { get; set; }
        public string VersionLabel { get; set; }
        public string VersionsLabel { get; set; }
        public string TestReportLabel { get; set; }
        public string TestReportsLabel { get; set; }
        public string EstimatedTimeLabel { get; set; }
        public string EstimationLabel { get; set; }
        public string EstimationsLabel { get; set; }
        public string EstimateLabel { get; set; }
        public string EstimatesLabel { get; set; }
        public string AuditLabel { get; set; }
        public string AuditsLabel { get; set; }
        public string ConductLabel { get; set; }
        public string ConductsLabel { get; set; }
        public string ActionLabel { get; set; }
        public string ActionsLabel { get; set; }
        public string TimelineLabel { get; set; }
        public string AuditActivityLabel { get; set; }
        public string AuditReportLabel { get; set; }
        public string AuditReportsLabel { get; set; }
        public string AuditAnalyticsLabel { get; set; }
        public string AuditQuestionLabel { get; set; }
        public string AuditQuestionsLabel { get; set; }
        public string ReportLabel { get; set; }
        public string ReportsLabel { get; set; }
        public string ClientLabel { get; set; }
        public string ClientsLabel { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("SoftLabelConfigurationId = " + SoftLabelConfigurationId);
            stringBuilder.Append(", ProjectLabel = " + ProjectLabel);
            stringBuilder.Append(", GoalLabel = " + GoalLabel);
            stringBuilder.Append(", EmployeeLabel = " + EmployeeLabel);
            stringBuilder.Append(", UserStoryLabel = " + UserStoryLabel);
            stringBuilder.Append(", DeadlineLabel = " + DeadlineLabel);
            stringBuilder.Append(", ProjectsLabel = " + ProjectsLabel);
            stringBuilder.Append(", GoalsLabel = " + GoalsLabel);
            stringBuilder.Append(", EmployeesLabel = " + EmployeesLabel);
            stringBuilder.Append(", DeadlinesLabel = " + DeadlinesLabel);
            stringBuilder.Append(", UserStoriesLabel = " + UserStoriesLabel);
            stringBuilder.Append(", ScenarioLabel = " + ScenarioLabel);
            stringBuilder.Append(", ScenariosLabel = " + ScenariosLabel);
            stringBuilder.Append(", RunLabel = " + RunLabel);
            stringBuilder.Append(", RunsLabel = " + RunsLabel);
            stringBuilder.Append(", VersionLabel = " + VersionLabel);
            stringBuilder.Append(", VersionsLabel = " + VersionsLabel);
            stringBuilder.Append(", TestReportLabel = " + TestReportLabel);
            stringBuilder.Append(", TestReportsLabel = " + TestReportsLabel);
            stringBuilder.Append(", EstimatedTimeLabel = " + EstimatedTimeLabel);
            stringBuilder.Append(", EstimationLabel = " + EstimationLabel);
            stringBuilder.Append(", EstimationsLabel = " + EstimationsLabel);
            stringBuilder.Append(", EstimateLabel = " + EstimateLabel);
            stringBuilder.Append(", EstimatesLabel = " + EstimatesLabel);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
