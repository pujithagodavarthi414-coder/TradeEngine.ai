using System;
using System.Collections.Generic;

namespace Btrak.Dapper.Dal.SpModels
{
    public class RoleSpEntity
    {
        public Guid? Id { get; set; }
        public Guid? RoleId { get; set; }

        public string RoleName { get; set; }

        public Guid? CompanyId { get; set; }

        public string Data { get; set; }

        public List<Guid> FeatureIds { get; set; }
        public string FeatureIdXml { get; set; }

        public int PageNo { get; set; } = 1;
        public int PageSize { get; set; } = 200;
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? OperationsPerformedBy { get; set; }
        public string Features { get; set; }
    }
}
