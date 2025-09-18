using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class LeadRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Lead table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(LeadDbEntity aLead)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLead.Id);
					 vParams.Add("@CompanyId",aLead.CompanyId);
					 vParams.Add("@CompanyName",aLead.CompanyName);
					 vParams.Add("@FirstName",aLead.FirstName);
					 vParams.Add("@LastName",aLead.LastName);
					 vParams.Add("@Email",aLead.Email);
					 vParams.Add("@ContactPhone",aLead.ContactPhone);
					 vParams.Add("@JobDescription",aLead.JobDescription);
					 vParams.Add("@Website",aLead.Website);
					 vParams.Add("@JobLinkUrl",aLead.JobLinkUrl);
					 vParams.Add("@Jobsalary",aLead.Jobsalary);
					 vParams.Add("@JobsalaryTypeId",aLead.JobsalaryTypeId);
					 vParams.Add("@JobTypeId",aLead.JobTypeId);
					 vParams.Add("@JobSkills",aLead.JobSkills);
					 vParams.Add("@JobSiteName",aLead.JobSiteName);
					 vParams.Add("@CountryId",aLead.CountryId);
					 vParams.Add("@Province",aLead.Province);
					 vParams.Add("@SkypeID",aLead.SkypeID);
					 vParams.Add("@PostalCode",aLead.PostalCode);
					 vParams.Add("@Street",aLead.Street);
					 vParams.Add("@Description",aLead.Description);
					 vParams.Add("@BirthDate",aLead.BirthDate);
					 vParams.Add("@Notes",aLead.Notes);
					 vParams.Add("@ResponsibleSalesExecutiveUserId",aLead.ResponsibleSalesExecutiveUserId);
					 vParams.Add("@LeadAddedByUserId",aLead.LeadAddedByUserId);
					 vParams.Add("@LeadOwnerUserId",aLead.LeadOwnerUserId);
					 vParams.Add("@Title",aLead.Title);
					 vParams.Add("@IsAPositiveContact",aLead.IsAPositiveContact);
					 vParams.Add("@Fax",aLead.Fax);
					 vParams.Add("@MobileNumber",aLead.MobileNumber);
					 vParams.Add("@LeadSourceId",aLead.LeadSourceId);
					 vParams.Add("@LeadStatusId",aLead.LeadStatusId);
					 vParams.Add("@IndustryId",aLead.IndustryId);
					 vParams.Add("@NoOfEmployees",aLead.NoOfEmployees);
					 vParams.Add("@RatingId",aLead.RatingId);
					 vParams.Add("@AnnualRevenue",aLead.AnnualRevenue);
					 vParams.Add("@MailChimpId",aLead.MailChimpId);
					 vParams.Add("@EmailOptOut",aLead.EmailOptOut);
					 vParams.Add("@MailChimpContactCreatedBy",aLead.MailChimpContactCreatedBy);
					 vParams.Add("@SecondaryEmail",aLead.SecondaryEmail);
					 vParams.Add("@Summary",aLead.Summary);
					 vParams.Add("@Twitter",aLead.Twitter);
					 vParams.Add("@CompanyHealthCheck",aLead.CompanyHealthCheck);
					 vParams.Add("@MailChimpStatus",aLead.MailChimpStatus);
					 vParams.Add("@MailChimpList",aLead.MailChimpList);
					 vParams.Add("@LinkedInUrl",aLead.LinkedInUrl);
					 vParams.Add("@CompanySize",aLead.CompanySize);
					 vParams.Add("@CompanyNo",aLead.CompanyNo);
					 vParams.Add("@Technologies",aLead.Technologies);
					 vParams.Add("@LinkedInConnectionsCount",aLead.LinkedInConnectionsCount);
					 vParams.Add("@MapUrl",aLead.MapUrl);
					 vParams.Add("@HeadQuarters",aLead.HeadQuarters);
					 vParams.Add("@ConfirmTime",aLead.ConfirmTime);
					 vParams.Add("@PersonelEmailId",aLead.PersonelEmailId);
					 vParams.Add("@UnsubCampaignTitleId",aLead.UnsubCampaignTitleId);
					 vParams.Add("@Euid",aLead.Euid);
					 vParams.Add("@OptionTime",aLead.OptionTime);
					 vParams.Add("@CompanyHQTime",aLead.CompanyHQTime);
					 vParams.Add("@UnsubTime",aLead.UnsubTime);
					 vParams.Add("@CompanyITBudget",aLead.CompanyITBudget);
					 vParams.Add("@UnsubCampaignId",aLead.UnsubCampaignId);
					 vParams.Add("@HQAddress1",aLead.HQAddress1);
					 vParams.Add("@EmployeeseniorityLevelId",aLead.EmployeeseniorityLevelId);
					 vParams.Add("@HQCity",aLead.HQCity);
					 vParams.Add("@CompanyRevenue",aLead.CompanyRevenue);
					 vParams.Add("@Revenue",aLead.Revenue);
					 vParams.Add("@HQAddress2",aLead.HQAddress2);
					 vParams.Add("@EmployeeJobFunctions",aLead.EmployeeJobFunctions);
					 vParams.Add("@HQCountry",aLead.HQCountry);
					 vParams.Add("@EmployeeAddress1",aLead.EmployeeAddress1);
					 vParams.Add("@SubIndustryId",aLead.SubIndustryId);
					 vParams.Add("@EmployeeCity",aLead.EmployeeCity);
					 vParams.Add("@EmployeeDepartmentId",aLead.EmployeeDepartmentId);
					 vParams.Add("@EmployeePostalCode",aLead.EmployeePostalCode);
					 vParams.Add("@EmployeeReportsTo",aLead.EmployeeReportsTo);
					 vParams.Add("@Openings",aLead.Openings);
					 vParams.Add("@EmployeeAddress2",aLead.EmployeeAddress2);
					 vParams.Add("@EmployeeState",aLead.EmployeeState);
					 vParams.Add("@EmployeeCountry",aLead.EmployeeCountry);
					 vParams.Add("@SourceUrl",aLead.SourceUrl);
					 vParams.Add("@PortfolioUrl",aLead.PortfolioUrl);
					 vParams.Add("@PostedJobUrl",aLead.PostedJobUrl);
					 vParams.Add("@Price",aLead.Price);
					 vParams.Add("@CampaignType",aLead.CampaignType);
					 vParams.Add("@LastCampaignName",aLead.LastCampaignName);
					 vParams.Add("@FollowUpDate",aLead.FollowUpDate);
					 vParams.Add("@CallStatusId",aLead.CallStatusId);
					 vParams.Add("@EmailStatusId",aLead.EmailStatusId);
					 vParams.Add("@LinkedinStatusId",aLead.LinkedinStatusId);
					 vParams.Add("@CompanyAnalysisDone",aLead.CompanyAnalysisDone);
					 vParams.Add("@CreatedDateTime",aLead.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLead.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLead.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLead.UpdatedByUserId);
					 vParams.Add("@NextActionDate",aLead.NextActionDate);
					 vParams.Add("@NextActionCompletedDate",aLead.NextActionCompletedDate);
					 vParams.Add("@IsArchive",aLead.IsArchive);
					 int iResult = vConn.Execute("USP_LeadInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Lead table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(LeadDbEntity aLead)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aLead.Id);
					 vParams.Add("@CompanyId",aLead.CompanyId);
					 vParams.Add("@CompanyName",aLead.CompanyName);
					 vParams.Add("@FirstName",aLead.FirstName);
					 vParams.Add("@LastName",aLead.LastName);
					 vParams.Add("@Email",aLead.Email);
					 vParams.Add("@ContactPhone",aLead.ContactPhone);
					 vParams.Add("@JobDescription",aLead.JobDescription);
					 vParams.Add("@Website",aLead.Website);
					 vParams.Add("@JobLinkUrl",aLead.JobLinkUrl);
					 vParams.Add("@Jobsalary",aLead.Jobsalary);
					 vParams.Add("@JobsalaryTypeId",aLead.JobsalaryTypeId);
					 vParams.Add("@JobTypeId",aLead.JobTypeId);
					 vParams.Add("@JobSkills",aLead.JobSkills);
					 vParams.Add("@JobSiteName",aLead.JobSiteName);
					 vParams.Add("@CountryId",aLead.CountryId);
					 vParams.Add("@Province",aLead.Province);
					 vParams.Add("@SkypeID",aLead.SkypeID);
					 vParams.Add("@PostalCode",aLead.PostalCode);
					 vParams.Add("@Street",aLead.Street);
					 vParams.Add("@Description",aLead.Description);
					 vParams.Add("@BirthDate",aLead.BirthDate);
					 vParams.Add("@Notes",aLead.Notes);
					 vParams.Add("@ResponsibleSalesExecutiveUserId",aLead.ResponsibleSalesExecutiveUserId);
					 vParams.Add("@LeadAddedByUserId",aLead.LeadAddedByUserId);
					 vParams.Add("@LeadOwnerUserId",aLead.LeadOwnerUserId);
					 vParams.Add("@Title",aLead.Title);
					 vParams.Add("@IsAPositiveContact",aLead.IsAPositiveContact);
					 vParams.Add("@Fax",aLead.Fax);
					 vParams.Add("@MobileNumber",aLead.MobileNumber);
					 vParams.Add("@LeadSourceId",aLead.LeadSourceId);
					 vParams.Add("@LeadStatusId",aLead.LeadStatusId);
					 vParams.Add("@IndustryId",aLead.IndustryId);
					 vParams.Add("@NoOfEmployees",aLead.NoOfEmployees);
					 vParams.Add("@RatingId",aLead.RatingId);
					 vParams.Add("@AnnualRevenue",aLead.AnnualRevenue);
					 vParams.Add("@MailChimpId",aLead.MailChimpId);
					 vParams.Add("@EmailOptOut",aLead.EmailOptOut);
					 vParams.Add("@MailChimpContactCreatedBy",aLead.MailChimpContactCreatedBy);
					 vParams.Add("@SecondaryEmail",aLead.SecondaryEmail);
					 vParams.Add("@Summary",aLead.Summary);
					 vParams.Add("@Twitter",aLead.Twitter);
					 vParams.Add("@CompanyHealthCheck",aLead.CompanyHealthCheck);
					 vParams.Add("@MailChimpStatus",aLead.MailChimpStatus);
					 vParams.Add("@MailChimpList",aLead.MailChimpList);
					 vParams.Add("@LinkedInUrl",aLead.LinkedInUrl);
					 vParams.Add("@CompanySize",aLead.CompanySize);
					 vParams.Add("@CompanyNo",aLead.CompanyNo);
					 vParams.Add("@Technologies",aLead.Technologies);
					 vParams.Add("@LinkedInConnectionsCount",aLead.LinkedInConnectionsCount);
					 vParams.Add("@MapUrl",aLead.MapUrl);
					 vParams.Add("@HeadQuarters",aLead.HeadQuarters);
					 vParams.Add("@ConfirmTime",aLead.ConfirmTime);
					 vParams.Add("@PersonelEmailId",aLead.PersonelEmailId);
					 vParams.Add("@UnsubCampaignTitleId",aLead.UnsubCampaignTitleId);
					 vParams.Add("@Euid",aLead.Euid);
					 vParams.Add("@OptionTime",aLead.OptionTime);
					 vParams.Add("@CompanyHQTime",aLead.CompanyHQTime);
					 vParams.Add("@UnsubTime",aLead.UnsubTime);
					 vParams.Add("@CompanyITBudget",aLead.CompanyITBudget);
					 vParams.Add("@UnsubCampaignId",aLead.UnsubCampaignId);
					 vParams.Add("@HQAddress1",aLead.HQAddress1);
					 vParams.Add("@EmployeeseniorityLevelId",aLead.EmployeeseniorityLevelId);
					 vParams.Add("@HQCity",aLead.HQCity);
					 vParams.Add("@CompanyRevenue",aLead.CompanyRevenue);
					 vParams.Add("@Revenue",aLead.Revenue);
					 vParams.Add("@HQAddress2",aLead.HQAddress2);
					 vParams.Add("@EmployeeJobFunctions",aLead.EmployeeJobFunctions);
					 vParams.Add("@HQCountry",aLead.HQCountry);
					 vParams.Add("@EmployeeAddress1",aLead.EmployeeAddress1);
					 vParams.Add("@SubIndustryId",aLead.SubIndustryId);
					 vParams.Add("@EmployeeCity",aLead.EmployeeCity);
					 vParams.Add("@EmployeeDepartmentId",aLead.EmployeeDepartmentId);
					 vParams.Add("@EmployeePostalCode",aLead.EmployeePostalCode);
					 vParams.Add("@EmployeeReportsTo",aLead.EmployeeReportsTo);
					 vParams.Add("@Openings",aLead.Openings);
					 vParams.Add("@EmployeeAddress2",aLead.EmployeeAddress2);
					 vParams.Add("@EmployeeState",aLead.EmployeeState);
					 vParams.Add("@EmployeeCountry",aLead.EmployeeCountry);
					 vParams.Add("@SourceUrl",aLead.SourceUrl);
					 vParams.Add("@PortfolioUrl",aLead.PortfolioUrl);
					 vParams.Add("@PostedJobUrl",aLead.PostedJobUrl);
					 vParams.Add("@Price",aLead.Price);
					 vParams.Add("@CampaignType",aLead.CampaignType);
					 vParams.Add("@LastCampaignName",aLead.LastCampaignName);
					 vParams.Add("@FollowUpDate",aLead.FollowUpDate);
					 vParams.Add("@CallStatusId",aLead.CallStatusId);
					 vParams.Add("@EmailStatusId",aLead.EmailStatusId);
					 vParams.Add("@LinkedinStatusId",aLead.LinkedinStatusId);
					 vParams.Add("@CompanyAnalysisDone",aLead.CompanyAnalysisDone);
					 vParams.Add("@CreatedDateTime",aLead.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aLead.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aLead.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aLead.UpdatedByUserId);
					 vParams.Add("@NextActionDate",aLead.NextActionDate);
					 vParams.Add("@NextActionCompletedDate",aLead.NextActionCompletedDate);
					 vParams.Add("@IsArchive",aLead.IsArchive);
					 int iResult = vConn.Execute("USP_LeadUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Lead table.
		/// </summary>
		public LeadDbEntity GetLead(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<LeadDbEntity>("USP_LeadSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Lead table.
		/// </summary>
		 public IEnumerable<LeadDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<LeadDbEntity>("USP_LeadSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
