using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.AdhocWork;
using Btrak.Services.AdhocWork;
using Btrak.Services.UserStory;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;
using Btrak.Models.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("AssignExplinationTaskActivityForDelayedTaskUsers")]
    [ExternalTaskVariableRequirements("CompanyName","TaskType","DelayInMinutes")]
    class AssignExplinationTaskActivityForDelayedTaskUsers : IExternalTaskAdapter
    {
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        public AssignExplinationTaskActivityForDelayedTaskUsers(ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _companyStructureService = companyStructureService;
            _emailService = emailService;
        }
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                string companyName = (string)externalTask.Variables["CompanyName"].Value;
                string taskType = (string)externalTask.Variables["TaskType"].Value;
                string delayMinutesInString = (string)externalTask.Variables["DelayInMinutes"].Value;

                var userStorySerice = Unity.UnityContainer.Resolve<UserStoryService>();

                if (!string.IsNullOrWhiteSpace(companyName) && !string.IsNullOrWhiteSpace(taskType) && !string.IsNullOrWhiteSpace(delayMinutesInString))
                {
                    var taskTypeDetails = userStorySerice.GetUserStoryTypeDetails(companyName, taskType);

                    if (taskTypeDetails != null)
                    {
                        int delayInMinutes = Convert.ToInt32(delayMinutesInString);

                        var delayedTasks = userStorySerice.GetDelayedTaskDetailsByDelayedMinutes(companyName, delayInMinutes, null);

                        if (delayedTasks != null && delayedTasks.Count > 0)
                        {
                            foreach (var task in delayedTasks)
                            {
                                var adhocWorkService = Unity.UnityContainer.Resolve<AdhocWorkService>();

                                var userStory = new AdhocWorkInputModel()
                                {
                                    UserStoryName = "Please submit the explanation why "+task.UserStoryName +" in "+task.ProjectName +" is delayed",
                                    UserStoryTypeId = taskTypeDetails.UserStoryTypeId,
                                    OwnerUserId = task.OwnerUserId,
                                    EstimatedTime = 2,
                                    DeadLineDate = DateTimeOffset.Now
                                };

                                var userDetails = new LoggedInContext
                                {
                                    LoggedInUserId = task.OwnerUserId
                                };

                                var userStoryId = adhocWorkService.UpsertAdhocWork(userStory, userDetails, new List<ValidationMessage>());

                                if (userStoryId != null && userStoryId != Guid.Empty)
                                {
                                    LoggedInContext loggedInContext = new LoggedInContext()
                                    {
                                        LoggedInUserId = new Guid(ConfigurationManager.AppSettings["CustomAppImportsUserId"].ToString()),
                                        CompanyGuid = new Guid(ConfigurationManager.AppSettings["CustomAppCompanyId"].ToString())
                                    };
                                    CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, new List<ValidationMessage>());
                                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, new List<ValidationMessage>(), companyDetails.SiteAddress);
                                    string[] emails = new[] { task.Email };
                                    var subject = task.UserStoryName + " deadline cross explanation reason task assignment notification";
                                    var htmlContent = "Dear " + task.Email + ",\n" + task.UserStoryName + " crossed the deadline on " + task.DeadLineDate + " and it is not done yet. So please give the explanation why it is delayed. Here is the link to give explanation " + ConfigurationManager.AppSettings["SiteUrl"] + "/projects/workitem/" + userStoryId;
                                    EmailGenericModel emailModel = new EmailGenericModel
                                    {
                                        SmtpServer = smtpDetails?.SmtpServer,
                                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                                        SmtpMail = smtpDetails?.SmtpMail,
                                        SmtpPassword = smtpDetails?.SmtpPassword,
                                        ToAddresses = emails,
                                        HtmlContent = htmlContent,
                                        Subject = subject,
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
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Execute", "AssignExplinationTaskActivityForDelayedTaskUsers", exception.Message), exception);

            }
        }
    }
}