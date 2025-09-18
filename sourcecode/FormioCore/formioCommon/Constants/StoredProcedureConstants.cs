using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioCommon.Constants
{
    public class StoredProcedureConstants
    {
        //Form
        public const string SpUpsertForm = "USP_UpsertGenericForm";
        public const string SpGetFormSubmitted = "USP_GetGenericFormSubmitted";
        public const string SpUpsertFormSubmitted = "USP_UpsertGenericFormSubmitted";
        public const string SpGetGenericForms = "USP_GetGenericForms_New";
        public const string SpInsertFormHistory = "USP_InsertFormHistory";
        //User
        public const string SpUpsertUserDetails = "USP_UpsertUserDetails";
        public const string SpGetSmtpCredentials = "USP_SearchSmtpCredentials";
        public const string SpGetAllHtmlTemplate = "USP_GetHtmlTemplate";
        public const string SpGetCompanySettings = "USP_GetCompanySettings";
        public const string SpGetTemplate = "USP_GetTemplate";
        public const string SpCompanyDetails = "USP_GetCompanyDetails";
        public const string SpGetCompanies = "USP_GetCompanies";
        public const string SpGetMailsCount = "USP_GetMailsCount";
        public const string SpInsertMail = "USP_InsertMail";
        //CustomApplications
        public const string SpGetCustomApplicationWorkflow = "USP_GetCustomApplicationWorkflow";
    }
}
