using Btrak.Models.User;
using Btrak.Models.Widgets;
using Postal;
using System.Collections.Generic;

namespace Btrak.Models.EmailTemplates
{
    public class EmailTemplateInputModel : Postal.Email
    {
        public EmailTemplateInputModel(string viewName) : base(viewName)
        {

        }

        public string FromEmailAddress
        {
            get;
            set;
        }

        public string FromName
        {
            get;
            set;
        }

        public string To
        {
            get;
            set;
        }

        public string ToName
        {
            get;
            set;
        }

        public string Cc
        {
            get;
            set;
        }

        /*Reset Password template details*/
        public ResetPasswordInputModel ResetPasswordModel
        {
            get;
            set;
        }

        public List<FileDetailsModel> FileUrl
        {
            get;
            set;
        }


        public string Subject
        {
            get;
            set;
        }

        public string MessageBody
        {
            get;
            set;
        }
    }
}
