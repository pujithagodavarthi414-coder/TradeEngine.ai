using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PolicyReviewTool
{
    public class PolicyDetailsToTable
    {
        public string RefId { get; set; }

        public string Description { get; set; }

        public DateTime ReviewDate { get; set; }

        public bool MustRead { get; set; }

        public bool HasRead { get; set; }

        public DateTime ReadDate { get; set; }

    }
}
