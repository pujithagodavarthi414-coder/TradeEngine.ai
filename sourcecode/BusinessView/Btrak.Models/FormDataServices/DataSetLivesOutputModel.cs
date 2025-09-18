using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class DataSetLivesOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public DataSetLivesConversionModel DataJson { get; set; }
        public string Name { get; set; }
        public string DataSourceName { get; set; }
        public string DataSourceType { get; set; }
        public bool? IsArchived { get; set; }
        public object DataSourceFormJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public int? TotalCount { get; set; }

    }

    public class DataSetLivesConversionModel
    {
        public object FormData { get; set; }
        public string ContractNumber { get; set; }
        public string ProgramName { get; set; }
        public object KPIs { get; set; }
        public string ProjectPeriod { get; set; }
        public string Image { get; set; }
        public List<Guid> UserIds { get; set; }
        public string Template { get; set; }
        public string ImageUrl { get; set; }
        public string ProgramUniqueId { get; set; }
        public Guid? CountryId { get; set; }


    }
}
