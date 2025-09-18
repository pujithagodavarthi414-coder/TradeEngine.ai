using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeWorkConfigurationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeWorkConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeWorkConfigurationDbEntity aEmployeeWorkConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeWorkConfiguration.Id);
					 vParams.Add("@EmployeeId",aEmployeeWorkConfiguration.EmployeeId);
					 vParams.Add("@MinAllocatedHours",aEmployeeWorkConfiguration.MinAllocatedHours);
					 vParams.Add("@MaxAllocatedHours",aEmployeeWorkConfiguration.MaxAllocatedHours);
					 vParams.Add("@ActiveFrom",aEmployeeWorkConfiguration.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeWorkConfiguration.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeWorkConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeWorkConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeWorkConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeWorkConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeWorkConfigurationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeWorkConfiguration table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeWorkConfigurationDbEntity aEmployeeWorkConfiguration)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeWorkConfiguration.Id);
					 vParams.Add("@EmployeeId",aEmployeeWorkConfiguration.EmployeeId);
					 vParams.Add("@MinAllocatedHours",aEmployeeWorkConfiguration.MinAllocatedHours);
					 vParams.Add("@MaxAllocatedHours",aEmployeeWorkConfiguration.MaxAllocatedHours);
					 vParams.Add("@ActiveFrom",aEmployeeWorkConfiguration.ActiveFrom);
					 vParams.Add("@ActiveTo",aEmployeeWorkConfiguration.ActiveTo);
					 vParams.Add("@CreatedDateTime",aEmployeeWorkConfiguration.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeWorkConfiguration.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeWorkConfiguration.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeWorkConfiguration.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeWorkConfigurationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeWorkConfiguration table.
		/// </summary>
		public EmployeeWorkConfigurationDbEntity GetEmployeeWorkConfiguration(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeWorkConfigurationDbEntity>("USP_EmployeeWorkConfigurationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeWorkConfiguration table.
		/// </summary>
		 public IEnumerable<EmployeeWorkConfigurationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeWorkConfigurationDbEntity>("USP_EmployeeWorkConfigurationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
