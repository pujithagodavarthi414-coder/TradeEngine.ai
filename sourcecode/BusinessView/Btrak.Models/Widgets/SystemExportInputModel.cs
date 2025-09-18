
using System;
using System.Collections.Generic;

namespace Btrak.Models.Widgets
{
    public class SystemExportInputModel
    {
        public bool? IsExportConfiguration { get; set; }
        public bool? IsExportDashboard { get; set; }
        public bool? IsExportData { get; set; }
        public List<Guid> WorkspaceIds { get; set; }
        public List<int> ExportDataModelIds { get; set; }
        public List<string> ExportDataModelNames { get; set; }
    }
}
