job("dsl job"){
    scm{
        git('git@github.com:prakshal-shah/devops-training.git') { node ->
            node / gitConfigName('prakshal-shah')
            node / gitConfigEmail('prakshal.einfochips@gmail.com')
            }
    }

    steps{
        shell("echo HOLA!!!!")
    }
}
