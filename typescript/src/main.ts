
const sql = require('mssql')
const rest = new (require('rest-mssql-nodejs'))({
	user: "sa2",
	password: "pass",
	server:"localhost",
	database:"Aseni"
});

setTimeout(async () => {
	const resultado= await rest.executeStoredProcedure('spEntregablesPorCanton',null,{
		CantonSol:'Turrialba'
	});

	console.log(resultado.data[0]);
}, 1500);


function Query1(){
	
}
