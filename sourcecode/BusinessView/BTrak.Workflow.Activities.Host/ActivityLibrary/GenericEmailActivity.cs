using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.SystemManagement;
using Btrak.Services.Email;
using BTrak.Common;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("email-activity")]
    public class GenericEmailActivity : IExternalTaskAdapter
    {
        private readonly IEmailService _emailService;

        public GenericEmailActivity(IEmailService emailService)
        {
            _emailService = emailService;
        }
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                var emailService = Unity.UnityContainer.Resolve<EmailService>();
                var goalRepository = Unity.UnityContainer.Resolve<GoalRepository>();
                var userRepository = Unity.UnityContainer.Resolve<UserRepository>(); 

                string toAddress = externalTask.Variables["toAddress"].Value != null ? (string)externalTask.Variables["toAddress"].Value : string.Empty; 
                string ccAddress = externalTask.Variables["ccAddress"].Value != null ? (string)externalTask.Variables["ccAddress"].Value : string.Empty; 
                string subject = externalTask.Variables["subject"].Value != null ? (string)externalTask.Variables["subject"].Value : string.Empty;  

                string htmlContent = externalTask.Variables["html"].Value != null ? (string)externalTask.Variables["html"].Value : string.Empty;
                
                string templateName = externalTask.Variables["templateName"].Value != null ? (string)externalTask.Variables["templateName"].Value : string.Empty;
                string templateTags = externalTask.Variables["templateTags"].Value != null ? (string)externalTask.Variables["templateTags"].Value : string.Empty; 
                string templateValues = externalTask.Variables["templateValues"].Value != null ? (string)externalTask.Variables["templateValues"].Value : string.Empty;

                var companyId =  (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;

                string html = string.Empty;

                if (!string.IsNullOrEmpty(templateName))
                {
                    html = goalRepository.GetHtmlTemplateByName(templateName, new Guid(companyId));
                }
                else
                {
                    html = htmlContent;
                }

                var loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };


                SmtpDetailsModel smtpDetails = userRepository.SearchSmtpCredentials(loggedInContext, new List<Btrak.Models.ValidationMessage>(), null);

                if (!string.IsNullOrEmpty(html))
                {
                    var templateTagsReplace = templateTags?.Split(',');
                    var templateValuesReplace = templateValues?.Split(',');

                    if(templateTagsReplace != null)
                    {
                        for (var i = 0; i <= templateTagsReplace.Length; i++)
                        {
                            html = html?.Replace(templateTagsReplace[i], templateValuesReplace[i]);
                        }
                    }
                }
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = new[] { toAddress },
                    HtmlContent = html,
                    Subject = subject,
                    CCMails = new[] { ccAddress },
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }
}