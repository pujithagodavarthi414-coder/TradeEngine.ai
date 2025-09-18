using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class ProgramDataSetUpsertModel
    {
        public string ProgramName { get; set; }
        public string ProjectPeriod { get; set; }
        public string Location { get; set; }
        public string Template { get; set; }
        public object FormData { get; set; }
        public List<Guid> UserIds { get; set; }
        public Guid? TemplateTypeId { get; set; }
        public Guid? CountryId { get; set; }
        public string ImageUrl { get; set; }
        public string ProgramUniqueId { get; set; }
    }
}
