using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.MasterDataValidationHelper;
using BTrak.Common;

namespace Btrak.Services.MasterData
{
    public class PaymentTypeService : IPaymentTypeService
    {
        private readonly PaymentTypeMasterDataRepository _paymentTypeMasterDataRepository;
        private readonly IAuditService _auditService;

        public PaymentTypeService(PaymentTypeMasterDataRepository paymentTypeMasterDataRepository, IAuditService auditService)
        {
            _paymentTypeMasterDataRepository = paymentTypeMasterDataRepository;
            _auditService = auditService;
        }

        public Guid? UpsertPaymentType(PaymentTypeUpsertModel paymentTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertPaymentType", "paymentTypeUpsertModel", paymentTypeUpsertModel, "payment type Service"));

            if (!PaymentTypeValidationHelper.UpsertPaymentTypeValidation(paymentTypeUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            paymentTypeUpsertModel.PaymentTypeId = _paymentTypeMasterDataRepository.UpsertPaymentType(paymentTypeUpsertModel, loggedInContext, validationMessages);

            LoggingManager.Debug("paymentType with the id " + paymentTypeUpsertModel.PaymentTypeId);

            _auditService.SaveAudit(AppCommandConstants.UpsertPaymentTypeCommandId, paymentTypeUpsertModel, loggedInContext);

            return paymentTypeUpsertModel.PaymentTypeId;
        }

        public List<GetPaymentTypeOutputModel> GetPaymentTypes(GetPaymentTypeSearchCriteriaInputModel getPaymentTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get payment Types", "getPaymentTypeSearchCriteriaInputModel", getPaymentTypeSearchCriteriaInputModel, "payment type Master Data Service"));
            _auditService.SaveAudit(AppCommandConstants.GetPaymentTypesCommandId, getPaymentTypeSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getPaymentTypeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting payment Types list ");
            List<GetPaymentTypeOutputModel> paymentList = _paymentTypeMasterDataRepository.GetPaymentTypes(getPaymentTypeSearchCriteriaInputModel, loggedInContext, validationMessages);
            return paymentList;
        }
    }
}