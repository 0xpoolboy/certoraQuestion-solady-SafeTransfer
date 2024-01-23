using MockERC20A as mainToken;
using MockERC20B as otherToken;
methods {
    function mainToken.balanceOf(address) external returns(uint256) envfree;

    function _.finalize(address client) external => clvHook_finalize(client) expect void;

    function _.balanceOf(address) external => DISPATCHER(true);
    function _.totalSupply() external => DISPATCHER(true);
    function _.transfer(address, uint256) external => DISPATCHER(true);
    function _.transferFrom(address, address, uint256) external => DISPATCHER(true);
    function _.approve(address, uint256) external => DISPATCHER(true);
}

ghost bool gFinalizeWasCalled {
    init_state axiom !gFinalizeWasCalled;
}

function clvHook_finalize(address client) {
    gFinalizeWasCalled = true;
}

rule sanity(
    env e,
    method f,
    calldataarg args
) {
    f(e, args);
    satisfy true;
}

rule balanceZeroWhenFinialized(
    env e,
    method f,
    calldataarg args
) {
    require !gFinalizeWasCalled;

    if (f.selector == sig:withdrawFromPool(address,uint256).selector) {
        address token;
        uint256 amount;

        require token == otherToken || token == mainToken;

        withdrawFromPool(e, token, amount);
    } else {
        f(e, args);
    }

    //satisfy gFinalizeWasCalled;
    assert gFinalizeWasCalled => mainToken.balanceOf(currentContract) == 0;
}