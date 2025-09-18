using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.WorkFlow;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.Status;
using Btrak.Services.Helpers.WorkFlow;
using Btrak.Services.Status;

namespace Btrak.Services.WorkFlow
{
    public class WorkFlowStatusService : IWorkFlowStatusService
    {

        private WorkflowStatuRepository _workFlowStatuRepository;
        private readonly StatusService _userStoryStatusService;
        private readonly WorkFlowRepository _workFlowRepository;

        private readonly IAuditService _auditService;

        public WorkFlowStatusService()
        { }

        public WorkFlowStatusService(WorkflowStatuRepository workflowStatuRepository, StatusService userStoryStatusService, IAuditService auditService, WorkFlowRepository workFlowRepository)
        {
            _workFlowStatuRepository = workflowStatuRepository;
            _userStoryStatusService = userStoryStatusService;
            _auditService = auditService;
            _workFlowRepository = workFlowRepository;
        }

        public Guid? UpsertWorkFlowStatus(WorkFlowStatusUpsertInputModel workFlowStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(workFlowStatusUpsertInputModel.ToString());

            if (!WorkFlowStatusValidations.ValidateUpsertWorkFlowStatus(workFlowStatusUpsertInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }
            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                workFlowStatusUpsertInputModel.TimeZone = userTimeDetails?.TimeZone;
            }
            if (workFlowStatusUpsertInputModel.TimeZone == null)
            {
                var indianTimeDetails = TimeZoneHelper.GetIstTime();
                workFlowStatusUpsertInputModel.TimeZone = indianTimeDetails?.TimeZone;
            }



            if (workFlowStatusUpsertInputModel.WorkFlowId != Guid.Empty)
            {
                var workFlowInputModel = new WorkFlowInputModel
                {
                    WorkFlowId = workFlowStatusUpsertInputModel.WorkFlowId
                };

                WorkFlowApiReturnModel workFlowSpReturnModel = _workFlowRepository.GetAllWorkFlows(workFlowInputModel, loggedInContext, validationMessages).SingleOrDefault();

                if (!WorkFlowValidations.ValidateWorkFlowFoundWithId(workFlowStatusUpsertInputModel.WorkFlowId, validationMessages, workFlowSpReturnModel))
                {
                    return null;
                }
            }
            if (workFlowStatusUpsertInputModel.StatusId?.Count > 0)
            {
                for (int i = 0; i < workFlowStatusUpsertInputModel.StatusId.Count; i++)
                {
                    UserStoryStatusApiReturnModel userStoryStatusModel = _userStoryStatusService.GetStatusById(workFlowStatusUpsertInputModel.StatusId[i], loggedInContext, validationMessages);
                    if (userStoryStatusModel == null)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.NotFoundUserStoryStatusWithTheId, workFlowStatusUpsertInputModel.WorkFlowId)
                        });

                        return null;
                    }
                }
            }

            if (workFlowStatusUpsertInputModel.WorkFlowStatusId == Guid.Empty || workFlowStatusUpsertInputModel.WorkFlowStatusId == null)
            {
                for (int i = 0; i < workFlowStatusUpsertInputModel.StatusId?.Count; i++)
                {
                    var workFlowStatusInputModel = new WorkFlowStatusInputModel
                    {
                        WorkFlowId = workFlowStatusUpsertInputModel.WorkFlowId,
                        UserStoryStatusId = workFlowStatusUpsertInputModel.StatusId[i],
                        IsArchived = false
                    };

                    List<WorkFlowStatusApiReturnModel> workFlowStatusReturnModels = _workFlowStatuRepository.GetAllWorkFlowStatus(workFlowStatusInputModel, loggedInContext, validationMessages);

                    if (workFlowStatusReturnModels != null && workFlowStatusReturnModels.Count > 0)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.AlreadyExistWorkFlowStatus, workFlowStatusUpsertInputModel.WorkFlowId, workFlowStatusUpsertInputModel.StatusId)
                        });

                        return null;
                    }
                }

                workFlowStatusUpsertInputModel.StatusIdXml = Utilities.ConvertIntoListXml(workFlowStatusUpsertInputModel.StatusId);

                workFlowStatusUpsertInputModel.WorkFlowId = _workFlowStatuRepository.UpsertWorkFlowStatus(workFlowStatusUpsertInputModel, loggedInContext, validationMessages);

                if (workFlowStatusUpsertInputModel.WorkFlowId != Guid.Empty)
                {
                    LoggingManager.Debug("New WorkFlowStatus with the id " + workFlowStatusUpsertInputModel.WorkFlowStatusId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertWorkFlowStatusCommandId, workFlowStatusUpsertInputModel, loggedInContext);

                    return workFlowStatusUpsertInputModel.WorkFlowId;
                }

                throw new Exception(ValidationMessages.ExceptionWorkFlowCouldNotBeCreated);
            }

            if (workFlowStatusUpsertInputModel.IsArchived)
            {
                workFlowStatusUpsertInputModel.StatusIdXml = Utilities.ConvertIntoListXml(workFlowStatusUpsertInputModel.StatusId);

                workFlowStatusUpsertInputModel.WorkFlowStatusId = _workFlowStatuRepository.UpsertWorkFlowStatus(workFlowStatusUpsertInputModel, loggedInContext, validationMessages);

                LoggingManager.Debug("WorkFlowStatus with the id " + workFlowStatusUpsertInputModel.WorkFlowStatusId + " has been updated.");

                _auditService.SaveAudit(AppCommandConstants.UpsertWorkFlowStatusCommandId, workFlowStatusUpsertInputModel, loggedInContext);

                return workFlowStatusUpsertInputModel.WorkFlowId;
            }

            workFlowStatusUpsertInputModel.StatusIdXml = Utilities.ConvertIntoListXml(workFlowStatusUpsertInputModel.StatusId);

            workFlowStatusUpsertInputModel.WorkFlowId = _workFlowStatuRepository.UpsertWorkFlowStatus(workFlowStatusUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("WorkFlowStatus with the id " + workFlowStatusUpsertInputModel.WorkFlowStatusId + " has been updated.");

            _auditService.SaveAudit(AppCommandConstants.UpsertWorkFlowStatusCommandId, workFlowStatusUpsertInputModel, loggedInContext);

            return workFlowStatusUpsertInputModel.WorkFlowId;
        }

        public List<WorkFlowStatusApiReturnModel> GetAllWorkFlowStatus(bool? isArchive, Guid? workFlowId, Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetAllWorkFlowStatus." + "Logged in User Id=" + loggedInContext + " isArchive=" + isArchive + " workFlowId=" + workFlowId + "statusId=" + statusId);

            WorkFlowStatusInputModel workFlowStatusInputModel = new WorkFlowStatusInputModel
            {
                IsArchived = isArchive,
                WorkFlowId = workFlowId,
                UserStoryStatusId = statusId,
            };

            // _auditService.SaveAudit(AppCommandConstants.GetAllWorkFlowStatusCommandId, workFlowStatusInputModel, loggedInContext);
            _workFlowStatuRepository = new WorkflowStatuRepository();

            List<WorkFlowStatusApiReturnModel> workFlowStatusReturnModels = _workFlowStatuRepository.GetAllWorkFlowStatus(workFlowStatusInputModel, loggedInContext, validationMessages);

            return workFlowStatusReturnModels;
        }

        public WorkFlowStatusApiReturnModel GetWorkflowStatusById(Guid? workFlowStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetWorkflowStatusById." + "Logged in User Id=" + loggedInContext + " workFlowStatusId=" + workFlowStatusId);

            if (!WorkFlowStatusValidations.ValidateWorkFlowStatusById(workFlowStatusId, loggedInContext, validationMessages))
            {
                return null;
            }

            var workFlowStatusInputModel = new WorkFlowStatusInputModel
            {
                WorkFlowStatusId = workFlowStatusId
            };

            WorkFlowStatusApiReturnModel workFlowStatusReturnModel = _workFlowStatuRepository.GetAllWorkFlowStatus(workFlowStatusInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!WorkFlowStatusValidations.ValidateWorkFlowStatusFoundWithId(workFlowStatusId, validationMessages, workFlowStatusReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetWorkflowStatusByIdCommandId, workFlowStatusInputModel, loggedInContext);

            return workFlowStatusReturnModel;
        }
    }
}