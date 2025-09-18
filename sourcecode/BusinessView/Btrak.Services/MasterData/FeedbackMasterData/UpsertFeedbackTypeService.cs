using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.MasterData.FeedbackTypeModel;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.MasterDataValidationHelper.FeedbackType;
using BTrak.Common;

namespace Btrak.Services.MasterData.FeedbackMasterData
{
    public class UpsertFeedbackTypeService : IUpsertFeedbackTypeService
    {
        private readonly FeedbackTypeMasterDataRepository _feedbackTypeMasterDataRepository;
        private readonly IAuditService _auditService;

        public UpsertFeedbackTypeService(FeedbackTypeMasterDataRepository feedbackTypeMasterDataRepository, IAuditService auditService)
        {
            _feedbackTypeMasterDataRepository = feedbackTypeMasterDataRepository;
            _auditService = auditService;
        }

        public Guid? UpsertFeedbackType(UpsertFeedbackTypeModel upsertFeedbackTypeModel,  LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Feebdback form Type", "upsertFeedbackTypeModel", upsertFeedbackTypeModel, "UpsertFeedbackForm Api"));

            if (!UpsertFeedbackTypeValidationHelper.UpsertFeedbackTypeValidation(upsertFeedbackTypeModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertFeedbackTypeModel.FeedbackTypeId = _feedbackTypeMasterDataRepository.UpsertFeedbackFormType(upsertFeedbackTypeModel, loggedInContext, validationMessages);

            LoggingManager.Debug("feedback type with the id " + upsertFeedbackTypeModel.FeedbackTypeId);

            _auditService.SaveAudit(AppCommandConstants.UpsertFeedbackTypeCommandId, upsertFeedbackTypeModel, loggedInContext);

            return upsertFeedbackTypeModel.FeedbackTypeId;
        }

        public List<GetFeedbackTypeSearchCriteriaInputModel> GetFeedbackTypes(GetFeedbackTypeSearchCriteriaInputModel getFeedbackTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get feedback Types", "getFeedbackTypeSearchCriteriaInputModel", getFeedbackTypeSearchCriteriaInputModel, "feedback Form Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetFeedbackTypesCommandId, getFeedbackTypeSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getFeedbackTypeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting feedback Type list");

            List<GetFeedbackTypeSearchCriteriaInputModel> feedbackTypeList = _feedbackTypeMasterDataRepository.GetFeedbackType(getFeedbackTypeSearchCriteriaInputModel, loggedInContext, validationMessages);
            return feedbackTypeList;
        }
    }
}