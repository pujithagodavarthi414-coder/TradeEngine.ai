using Btrak.Models.User;
using Postal;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveApplicationMailTemplateModel : Postal.Email
    {
        public LeaveApplicationMailTemplateModel(string viewName) : base(viewName)
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

       
        public LeaveApplicationOutputModel LeaveApplicationOutputModel
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

