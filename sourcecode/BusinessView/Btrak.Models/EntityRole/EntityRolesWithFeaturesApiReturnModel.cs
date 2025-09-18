using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.EntityRole
{
    public class EntityRolesWithFeaturesApiReturnModel
    {
        public Guid? EntityRoleId { get; set; }
        public string EntityRoleName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Features { get; set; }

    }
}
