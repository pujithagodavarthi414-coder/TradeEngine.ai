using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Widgets
{
    public class SendWidgetReportModel
    {
        public string FileName { get; set; }
        public string FileExtension { get; set; }
        public string File { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public bool IsFromProcessApp { get; set; }
        public string ReportType { get; set; }
        public string[] ToEmails { get; set; }
        public Columnmodel[] Columns { get; set; }
        public List<object> Data { get; set; }
    }
    public class Columnmodel
    {
        public string Field { get; set; }
        public string ColumnAltName { get; set; }
        public string Title { get; set; }
        public bool Hidden { get; set; }
    }
}
