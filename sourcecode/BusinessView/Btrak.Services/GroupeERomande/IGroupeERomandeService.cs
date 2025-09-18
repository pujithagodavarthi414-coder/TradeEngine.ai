using Btrak.Models;
using Btrak.Models.EntryForm;
using Btrak.Models.GrERomande;
using Btrak.Models.MessageFieldType;
using Btrak.Models.TVA;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.GroupeERomande
{
    public interface IGroupeERomandeService
    {
        Task<Guid?> UpsertGroupe(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GrERomandeSearchOutputModel> GetGroupe(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> DownloadOrSendRomandDInvoice(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SendRomandDInvoiceEmail(GrERomandeSearchInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTVA(TVAInputModel tvaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TVASearchOutputModel> GetTVA(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEntryFormField(EntryFormUpsertInputModel entryFormInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EntryFormFieldReturnOutputModel> GetEntryFormField(EntryFormFieldSearchInputModel entryFormSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEntryFormFieldType(FieldTypeSearchModel fieldTypeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FieldTypeSearchModel> GetEntryFormFieldType(FieldTypeSearchModel entryFormFieldSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GreRomandeHistoryOutputModel> GetGroupeRomandeHistory(GrERomandeSearchInputModel grERomandeSearchInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateGreRomonadeHistory(GrERomandeInputModel grERomandeInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertMessageFieldType(MessageFieldTypeOutputModel entryFormInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MessageFieldTypeOutputModel> GetMessageFieldType(MessageFieldSearchInputModel entryFormSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
