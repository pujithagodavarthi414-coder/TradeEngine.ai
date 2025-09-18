using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeSkillRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeSkill table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeSkillDbEntity aEmployeeSkill)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeSkill.Id);
					 vParams.Add("@EmployeeId",aEmployeeSkill.EmployeeId);
					 vParams.Add("@SkillId",aEmployeeSkill.SkillId);
					 vParams.Add("@MonthsOfExprience",aEmployeeSkill.MonthsOfExprience);
					 vParams.Add("@DateFrom",aEmployeeSkill.DateFrom);
					 vParams.Add("@DateTo",aEmployeeSkill.DateTo);
					 vParams.Add("@Comments",aEmployeeSkill.Comments);
					 int iResult = vConn.Execute("USP_EmployeeSkillInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeSkill table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeSkillDbEntity aEmployeeSkill)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeSkill.Id);
					 vParams.Add("@EmployeeId",aEmployeeSkill.EmployeeId);
					 vParams.Add("@SkillId",aEmployeeSkill.SkillId);
					 vParams.Add("@MonthsOfExprience",aEmployeeSkill.MonthsOfExprience);
					 vParams.Add("@DateFrom",aEmployeeSkill.DateFrom);
					 vParams.Add("@DateTo",aEmployeeSkill.DateTo);
					 vParams.Add("@Comments",aEmployeeSkill.Comments);
					 int iResult = vConn.Execute("USP_EmployeeSkillUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeSkill table.
		/// </summary>
		public EmployeeSkillDbEntity GetEmployeeSkill(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeSkillDbEntity>("USP_EmployeeSkillSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeSkill table.
		/// </summary>
		 public IEnumerable<EmployeeSkillDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeSkillDbEntity>("USP_EmployeeSkillSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeSkill table by a foreign key.
		/// </summary>
		public List<EmployeeSkillDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeSkillDbEntity>("USP_EmployeeSkillSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
