
const common = {
  max_restarts: 2,
  interpreter: "none",
  instances: 1,
}
const v2ay_config_filepath = 'conf/v2ray.json'

module.exports = {
  apps:[
    {
      ...common,
      "name": 'caddy',
      "script": "caddy",
      "args": [
        "--conf", "conf/caddy.conf",
        "--log", "stdout",
      ]
    },
  ],
}

const pm2 = require('pm2')
async function SetV2ray(){
  let pm2connect = new Promise((rl,rj)=>{
    pm2.connect(err=>{
      if(err)return rj(err);
      rl()
    })
  })
  let generateConfig = require('@shynome/v2ray_generator/dist/lib/generator_config').main(v2ay_config_filepath)
  await  Promise.all([
    pm2connect,
    generateConfig,
  ])
  await new Promise((rl,rj)=>{
    pm2.start({
      ...common,
      "name": 'v2ray',
      "script": "v2ray",
      "args": [
        "-config", v2ay_config_filepath,
      ],
    },(err,proc)=>{
      if(err)return rj(err);
      rl(proc)
    })
  })
}

1 && SetV2ray().catch((err)=>{
  console.error(err && err.stack || err)
  pm2.killDaemon((err)=>{
    if(err){
      console.log("kill pm2 daemon fail:")
      console.error(err && err.stack || err)
      return
    }
  })
})
