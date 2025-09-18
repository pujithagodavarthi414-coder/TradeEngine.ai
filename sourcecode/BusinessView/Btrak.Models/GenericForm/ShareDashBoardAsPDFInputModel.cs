using Btrak.Models.Widgets;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class ShareDashBoardAsPDFInputModel
    {
        public List<FileBytesModel> FileBytes { get; set; }
        public string DashboardName {  get; set; }
        public string[] ToAddresses { get; set; }
        public string Message { get; set; }
        public string Subject { get; set; }
        public string[] CCMails { get; set; }
        public string[] BCCMails { get; set; }
    }
}
