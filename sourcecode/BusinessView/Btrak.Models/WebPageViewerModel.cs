using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class WebPageViewerModel
    {
        public Guid? _id { get; set; }
        public string Path { get; set; }
        public Guid TemplateId { get; set; }
        public Guid CompanyId { get; set; }
    }
}
