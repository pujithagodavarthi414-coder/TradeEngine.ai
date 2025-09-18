using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerIdleRolesModel
    {
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public int? IdleAlertTime { get; set; }
        public int? IdleScreenShotCaptureTime { get; set; }
        public int? MinimumIdelTime { get; set; }
    }
}
