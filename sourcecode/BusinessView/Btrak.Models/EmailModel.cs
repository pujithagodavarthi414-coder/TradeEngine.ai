using Postal;

namespace Btrak.Models
{
    public class EmailModel : Postal.Email
    {
        public EmailModel(string viewName) : base(viewName)
        {

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
        public ResetPasswordModel ResetPasswordModel
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
