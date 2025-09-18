using System;
using System.Collections.Generic;
using BTrak.Common;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Btrak.Models.AdhocWork;
using Btrak.Services.Account;
using Btrak.Services.AdhocWork;
using Btrak.Services.GenericForm;
using Btrak.Services.UserStory;
using Dapper;
using Unity;
using Btrak.Models;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using Btrak.Models.GenericForm;
using System.Linq;
using Btrak.Services.ComplianceAudit;
using Btrak.Models.ComplianceAudit;
using Btrak.Dapper.Dal.Repositories;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("adhoc-userstory")]
    public class GenericAdhocUserStoryActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {

                string referenceId = externalTask.Variables.ContainsKey("referenceId") && externalTask.Variables["referenceId"]?.Value != null ? Convert.ToString(externalTask.Variables["referenceId"].Value) : string.Empty;
                string referenceTypeId = externalTask.Variables.ContainsKey("referenceTypeId") && externalTask.Variables["referenceTypeId"]?.Value != null ? (string)externalTask.Variables["referenceTypeId"].Value : string.Empty;
                string loggedUserId = externalTask.Variables.ContainsKey("loggedUserId") && externalTask.Variables["loggedUserId"]?.Value != null ? Convert.ToString(externalTask.Variables["loggedUserId"].Value) : string.Empty;
                string companyId = externalTask.Variables.ContainsKey("companyId") && externalTask.Variables["companyId"]?.Value != null ? (string)externalTask.Variables["companyId"].Value : string.Empty;
                string responsibleUser = externalTask.Variables.ContainsKey("responsibleUser") && externalTask.Variables["responsibleUser"]?.Value != null ? Convert.ToString(externalTask.Variables["responsibleUser"].Value) : string.Empty;
                string fileIds = externalTask.Variables.ContainsKey("fileIds") && externalTask.Variables["fileIds"]?.Value != null ? Convert.ToString(externalTask.Variables["fileIds"].Value) : string.Empty;
                foreach (var parameter in externalTask.Variables)
                {
                    resultVariables.Add(parameter.Key, externalTask.Variables[parameter.Key].Value);
                }
                var userStoryService = Unity.UnityContainer.Resolve<UserStoryService>();
                var userRepository = Unity.UnityContainer.Resolve<UserRepository>();
                var userStoryReplanService = Unity.UnityContainer.Resolve<UserStoryReplanTypeService>();
                var userService = Unity.UnityContainer.Resolve<UserService>();
                var adhocWorkService = Unity.UnityContainer.Resolve<AdhocWorkService>();
                var auditService = Unity.UnityContainer.Resolve<ComplianceAuditService>();

                var loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                Guid? refId = null;
                if (referenceId != null)
                {
                    Guid outGuidVariable;
                    Guid.TryParse(referenceId, out outGuidVariable);
                    refId = outGuidVariable;
                }

                var validationMessages = new List<ValidationMessage>();
                var userStoryTypeModel = new Btrak.Models.MasterData.UserStoryTypeSearchInputModel();
                userStoryTypeModel.GenericStatusType = true;
                var userStoryTypeId = userStoryReplanService.GetUserStoryTypes(userStoryTypeModel, loggedInContext, validationMessages).Where(x => x.IsApproveOrDecline != null && x.IsApproveOrDecline.Value).Select(x => x.UserStoryTypeId).FirstOrDefault();
                LoggingManager.Debug("userStoryTypeId:" + userStoryTypeId?.ToString());
                Guid? userId = null;
                if(!string.IsNullOrEmpty(responsibleUser))
                {
                    userId = userRepository.GetUserDetailsByNameAndCompanyId(responsibleUser, new Guid(companyId))?.Id;
                }
                var name = string.Empty;
                if (referenceTypeId == AppConstants.AuditsReferenceTypeId.ToString())
                {
                    AuditComplianceApiInputModel auditComplianceApiInputModel = new AuditComplianceApiInputModel() { AuditId = refId };

                    var auditDetails = auditService.SearchAudits(auditComplianceApiInputModel, loggedInContext, validationMessages).FirstOrDefault();
                    userId = (userId != null && userId != Guid.Empty) ? userId : auditDetails.ResponsibleUserId;
                    name = auditDetails.AuditName;
                } else if(referenceTypeId == AppConstants.ConductsReferenceTypeId.ToString())
                {
                    AuditConductApiInputModel auditConductApiInputModel = new AuditConductApiInputModel() { ConductId = refId };
                    var conductDetails = auditService.SearchAuditConducts(auditConductApiInputModel, loggedInContext, validationMessages).FirstOrDefault();
                    userId = (userId != null && userId != Guid.Empty) ? userId : conductDetails.ResponsibleUserId;
                    name = conductDetails.AuditConductName;
                }
                else if (referenceTypeId == AppConstants.AuditQuestionsReferenceTypeId.ToString())
                {
                    AuditQuestionsApiInputModel auditQuestionsApiInputModel = new AuditQuestionsApiInputModel() { AuditConductQuestionId = refId };
                    var questionDetails = auditService.SearchAuditConductQuestions(auditQuestionsApiInputModel, loggedInContext, validationMessages).FirstOrDefault();
                    userId = (userId != null && userId != Guid.Empty) ? userId : new Guid(loggedUserId);
                    name = questionDetails.QuestionName;
                } else if(referenceTypeId == AppConstants.EvidenceUploadReferenceTypeId.ToString())
                {
                    name = "Files";
                }

                if (!string.IsNullOrEmpty(referenceId) && !string.IsNullOrEmpty(referenceTypeId))
                {

                    var userStory = new AdhocWorkInputModel()
                    {
                        UserStoryName = name + " was submitted. Please verify and approve.",
                        UserStoryTypeId = userStoryTypeId,
                        OwnerUserId = userId,
                        ReferenceId = refId,
                        ReferenceTypeId = Guid.Parse(referenceTypeId),
                        IsWorkflowStatus = true,
                        FileIds = fileIds
                    };
                    var loggedInContextUser = new LoggedInContext
                    {
                        LoggedInUserId = new Guid(userId.ToString()),
                        CompanyGuid = new Guid(companyId)
                    };


                    Guid? adhocWorkId = adhocWorkService.UpsertAdhocWork(userStory, loggedInContext, validationMessages);
                    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString))
                    {

                        DynamicParameters parameters = new DynamicParameters();
                        parameters.Add("@TaskId", new Guid(externalTask.ProcessInstanceId));
                        parameters.Add("@UserStoryId", adhocWorkId);
                        parameters.Add("@ReferenceId", refId);
                        parameters.Add("@ReferenceTypeId", Guid.Parse(referenceTypeId));

                        conn.Query<UserstoryReferences>("USP_UpdateWorkflowTask", parameters, commandType: CommandType.StoredProcedure);
                    }
                    //resultVariables.Add("userStoryId", adhocWorkId);
                }

            }
            catch (Exception ex)
            {
                LoggingManager.Error(ex);
                throw ex;
            }

        }
    }
}
