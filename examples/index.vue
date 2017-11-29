<template>
	<div class="conatiner">
		<text style="margin-bottom: 20px;">weex plugin examples</text>
		<div @click="createAction" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;"><text style="color:#fff">hello world</text></div>
	</div>
</template>

<style>
	.container{
		flex: 1;
	}
</style>

<script>

	const plugin = weex.requireModule('getuiPush');

    plugin.initPush({
        appId:'2bRNIkGbJW9Jer3TSCyJG3',
        appKey:'7xbp4G1ujR8IOIe4S3uLg4',
        appSecret:'HXE8wGI7jc8yjfZZPE8s67',
    });

    plugin.onRegisterClient(function (clientId) {
        console.log('js 收到' + clientId);
    });

    plugin.onReceivePayloadData(function (payloadData) {
        console.log('js 收到' + JSON.stringify(payloadData));
    });

	module.exports = {
		data: {
			value: '',
			index: 0,
			txtChange: ''
		},
		methods: {
			createAction: function() {
//				plugin.initPush({
//				    test:1
//                });

			}
		}
	}
</script>