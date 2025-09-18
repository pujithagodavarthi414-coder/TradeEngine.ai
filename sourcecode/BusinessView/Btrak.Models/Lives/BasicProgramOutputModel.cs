using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Lives
{
    public class BasicProgramOutputModel
    {
        public string ProgramName { get; set; }
        public string ProjectPeriod { get; set; }
        public string Image { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? ProgramId { get; set; }
        public Guid? CountryId { get; set; }
        public object FormData { get; set; }
        public List<Guid> UserIds { get; set; }
        public Guid? CreatedBy { get; set; }
        public string Template { get; set; }

        public object KPI1 { get; set; }
        public object KPI2 { get; set; }
        public object KPI3 { get; set; }
        public string ImageUrl { get; set; }
        public string ProgramUniqueId { get; set; }
        

    }
}
