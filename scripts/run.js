

const main = async () => { //Hardhat Runtime Environment, o HRE para abreviar, es un objeto que contiene toda la funcionalidad que Hardhat expone cuando ejecuta una tarea, prueba o script. En realidad, Hardhat es el HRE.
    // const [owner, randomPerson] = await hre.ethers.getSigners(); //Para implementar algo en la cadena de bloques, ¡necesitamos tener una dirección de billetera! Hardhat hace esto por nosotros mágicamente en segundo plano
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); // Esto realmente compilará nuestro contrato y generará los archivos necesarios que necesitamos para trabajar con nuestro contrato en el artifactsdirectorio
    const waveContract = await waveContractFactory.deploy({ //Lo que sucede aquí es que Hardhat creará una red Ethereum local para nosotros
      value: hre.ethers.utils.parseEther("0.1"), // Aquí es donde digo, "vaya, implemente mi contrato y fináncielo con 0.1 ETH". Esto eliminará ETH de mi billetera y lo usará para financiar el contrato
    }); 

    await waveContract.deployed(); //Esperaremos hasta que nuestro contrato se implemente oficialmente en nuestra cadena de bloques local
    console.log("Contract deployed to:", waveContract.address); // nos dará la dirección del contrato desplegado
    // console.log("Contract deployed by:", owner.address);//para ver la dirección de la persona que implementa nuestro contrato.Solo por curiosidad.

    //Get Contract balance
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);//Uso una función que ethersme da aquí llamada getBalancey le paso la dirección de mi contrato!
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance)); //para ver si mi contrato realmente tiene un saldo de 0.1

    // let waveCount; //Básicamente, ¡necesitamos llamar manualmente a nuestras funciones!
    // waveCount = await waveContract.getTotalWaves(); //Al igual que lo haríamos con cualquier API normal.Primero llamo a la función para tomar el # de ondas totales.
    // console.log(waveCount.toNumber()); 

    const waveTxn = await waveContract.wave("This is wave #1");
  await waveTxn.wait();

  const waveTxn2 = await waveContract.wave("This is wave #2");
  await waveTxn2.wait();
    
    // let waveTxn = await waveContract.wave("A message!"); //Entonces, hago la ola. 
    // await waveTxn.wait();// Wait for the transaction to be mined

    //Get Contract balance to see what happened!
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance));

    // const [_, randomPerson] = await hre.ethers.getSigners();
    // waveTxn = await waveContract.connect(randomPerson).wave("Another message");
    // await waveTxn.wait(); // Wait for the transaction to be mined

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    // waveCount = await waveContract.getTotalWaves(); //Finalmente, agarro el waveCount una vez más para ver si cambió.

    // waveTxn = await waveContract.connect(randomPerson).wave(); // así es como podemos simular que otras personas accedan a nuestras funciones 
    // await waveTxn.wait(); //para poder obetener mas saludos

    // waveCount = await waveContract.getTotalWaves();
};
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0); // exit Node process without error
    } catch (error) {
      console.log(error);
      process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
    // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
  };
  
  runMain();