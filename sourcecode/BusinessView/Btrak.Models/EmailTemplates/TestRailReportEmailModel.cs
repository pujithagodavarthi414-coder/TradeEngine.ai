using Btrak.Models.TestRail;
using Postal;

namespace Btrak.Models.EmailTemplates
{
    public class TestRailReportEmailModel : Postal.Email
    {
        public TestRailReportEmailModel(string viewName) : base(viewName)
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

        /*Report details*/
        public ReportsEmailInputModel ReportsModel
        {
            get;
            set;
        }

        public string Subject
        {
            get;
            set;
        }


        public string PdfUrl
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
