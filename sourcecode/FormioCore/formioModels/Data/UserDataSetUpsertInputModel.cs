using System;
using System.Collections.Generic;

namespace formioModels.Data
{
    public class UserDataSetUpsertInputModel
    {

        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public List<Guid> DataSetIds { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ArchivedByUserId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public DateTime? ArchivedDateTime { get; set; }
    }
}
