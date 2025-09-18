using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Models.File;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web;

namespace Btrak.Services.BillingManagement
{

    public interface IScheduleService
    {   
        List<ScheduleOutputModel> GetInvoiceSchedules(ScheduleInputModel scheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInvoiceSchedule(UpsertInvoiceScheduleInputModel upsertInvoiceScheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ScheduleTypeOutputModel> GetScheduleTypes(ScheduleTypeInputModel scheduleTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ScheduleSequenceOutputModel> GetScheduleSequence(ScheduleSequenceInputModel scheduleSequenceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}