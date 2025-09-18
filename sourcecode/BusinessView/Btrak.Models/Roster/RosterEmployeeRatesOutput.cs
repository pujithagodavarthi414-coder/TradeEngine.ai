using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterEmployeeRatesOutput
    {
        public int Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public Guid EmployeeId { get; set; }
        public float Rate { get; set; }
        public bool IsPermanent { get; set; }
    }
}
