using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.Work;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.WorkFlow;
using BTrak.Common;
using Newtonsoft.Json;

namespace Btrak.Services.Work
{
    public class WorkService : IWorkService
    {
        private readonly WorkRepository _workRepository;
        private readonly IAuditService _auditService;
        private readonly JsonSerializerSettings _jsonSerializerSettings;

        public WorkService(WorkRepository workRepository, IAuditService auditService, JsonSerializerSettings jsonSerializerSettings)
        {
            _workRepository = workRepository;
            _auditService = auditService;
            _jsonSerializerSettings = jsonSerializerSettings;
        }

        public Guid? UpsertWork(WorkUpsertInputModel workUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(workUpsertInputModel.ToString());

            if (!WorkServiceValidations.UpsertWorkValidations(workUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            var workJsonData = JsonConvert.DeserializeObject<WorkJsonUpsertInputModel>(workUpsertInputModel.WorkJson, _jsonSerializerSettings);

            if (workJsonData.WorkTypeId == Guid.Empty || workJsonData.WorkTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.WorkTypeIdIsRequired)
                });
                return null;
            }

            if (string.IsNullOrEmpty(workJsonData.Message))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.MessageIsRequired)
                });
                return null;
            }

            if (workUpsertInputModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.DateIsRequired)
                });
                return null;
            }

            if (workUpsertInputModel.UserId == null || workUpsertInputModel.UserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.UserIdIsRequired)
                });
                return null;
            }

            workUpsertInputModel.WorkId = _workRepository.UpsertWork(workUpsertInputModel, loggedInContext, validationMessages);

            if (workUpsertInputModel.WorkId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert work audit saving", "work Service"));

                _auditService.SaveAudit(AppCommandConstants.UpsertWorkCommandId, workUpsertInputModel, loggedInContext);

                return workUpsertInputModel.WorkId;
            }

            LoggingManager.Debug(workUpsertInputModel.WorkId?.ToString());

            return null;
        }

        public WorkApiReturnModel GetWorkById(Guid? workId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Work By Id", "work Service"));

            if (!WorkServiceValidations.GetWorkByIdValidations(workId, loggedInContext, validationMessages))
            {
                return null;
            }

            WorkApiReturnModel workApiReturnModel = _workRepository.GetWorkById(workId, loggedInContext, validationMessages);

            if (workApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.WorkDetailsNotFound, workId)
                });
            }

            if (validationMessages.Any()) return null;


            LoggingManager.Debug(workApiReturnModel?.ToString());

            return workApiReturnModel;
        }
    }
}
