using Btrak.Models.User;
using Postal;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveApplicationEmailTemplate : Postal.Email
    {
        public LeaveApplicationEmailTemplate(string viewName) : base(viewName)
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
