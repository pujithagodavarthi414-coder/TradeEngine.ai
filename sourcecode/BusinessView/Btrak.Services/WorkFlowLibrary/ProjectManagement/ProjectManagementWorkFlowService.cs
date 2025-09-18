using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.UserStory;
using Btrak.Services.Email;
using Btrak.Services.Employee;
using Btrak.Services.UserStory;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.CompanyStructure;

namespace Btrak.Services.WorkFlowLibrary.ProjectManagement
{
    public class ProjectManagementWorkFlowService : IProjectManagementWorkFlowService
    {
        private readonly IUserStoryService _userStoryService;
        private readonly IEmployeeService _employeeService;
        private readonly IEmailService _emailService;
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ICompanyStructureService _companyStructureService;

        public ProjectManagementWorkFlowService(ICompanyStructureService companyStructureService, IUserStoryService userStoryService, IEmployeeService employeeService, IEmailService emailService)
        {
            _userStoryService = userStoryService;
            _employeeService = employeeService;
            _emailService = emailService;
            _companyStructureService = companyStructureService;
        }

        public ProjectManagementWorkFlowService()
        {

        }

        public void StartWorkItemAssignedWorkFlow(Guid userStoryId, LoggedInContext loggedInContext)
        {
            var validationMessages = new List<ValidationMessage>();
            UserStoryApiReturnModel userStoryDetails =
                _userStoryService.GetUserStoryById(userStoryId, null, loggedInContext, new List<ValidationMessage>());

            if (userStoryDetails?.OwnerUserId != null)
            {
                EmployeeOutputModel receiverDetails = _employeeService.GetEmployeeById(userStoryDetails.OwnerUserId, loggedInContext,
                    new List<ValidationMessage>());

                EmployeeOutputModel senderDetails = _employeeService.GetEmployeeById(loggedInContext.LoggedInUserId, loggedInContext,
                    new List<ValidationMessage>());

                if (senderDetails != null && receiverDetails != null)
                {
                    CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, new List<ValidationMessage>());
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), companyDetails.SiteAddress);
                    var formattedHtml = userStoryDetails.UserStoryName + " is assigned to you by " + senderDetails.FirstName + " " + senderDetails.SurName + ". Here is the link for it " + ConfigurationManager.AppSettings["SiteUrl"] + "/workitem/" + userStoryId;
                    string[] emails = new[] { receiverDetails.Email };
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = emails,
                        HtmlContent = formattedHtml,
                        Subject = "User story assigned",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
            }
        }
    }
}