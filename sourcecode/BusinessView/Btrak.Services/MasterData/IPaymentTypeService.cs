using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MasterData
{
    public interface IPaymentTypeService
    {
        Guid? UpsertPaymentType(PaymentTypeUpsertModel paymentTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetPaymentTypeOutputModel> GetPaymentTypes(GetPaymentTypeSearchCriteriaInputModel getPaymentTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}