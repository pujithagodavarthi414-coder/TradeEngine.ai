using System;
using System.Collections.Generic;

namespace formioModels.Data
{
    public class UserDataSetInputModel
    {
        public List<Guid> UserId { get; set; }
        public List<Guid> DataSetIds { get; set; }
        public Guid? CompanyId { get; set; }
    }
}
