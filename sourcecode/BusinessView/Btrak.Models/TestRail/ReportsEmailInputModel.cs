using System;
using System.Collections.Generic;

namespace Btrak.Models.TestRail
{
    public class ReportsEmailInputModel
    {
        public string ReportName { get; set; }

        public Guid? ReportId { get; set; }

        public string PdfUrl { get; set; }

        //public string EmailString { get; set; }

        public string ToUsers { get; set; }
    }
}
